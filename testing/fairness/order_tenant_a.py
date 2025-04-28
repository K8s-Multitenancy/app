import random
from uuid import uuid4
from locust import HttpUser, SequentialTaskSet, LoadTestShape, constant, task
from config_tenant_a import AUTH_MS_BASE_URL, ORDERS_MS_BASE_URL, PRODUCTS_MS_BASE_URL

def generate_random_phone_number():
    prefix = random.choice(["0812", "0813", "0821", "0857", "0878"])
    number = ''.join(random.choices("0123456789", k=8))
    return prefix + number

class TestScenario(SequentialTaskSet):
    @task
    def preparation(self):
        username = f"user-{str(uuid4())}"

        # Register
        register_payload = {
            "username": username,
            "email": f"{username}@gmail.com",
            "password": "TestUser1010",
            "full_name": username,
            "address": "Fasilkom UI, Depok",
            "phone_number": generate_random_phone_number()
        }
        register_response = self.client.post(f"{AUTH_MS_BASE_URL}/user/register", json=register_payload)
        register_response.raise_for_status()
        register_data = register_response.json()
        self.user_id = register_data[0]["id"]  # Pastikan key ini sesuai API response kamu

        # Login
        login_payload = {
            "username": register_payload["username"],
            "password": register_payload["password"]
        }
        login_response = self.client.post(f"{AUTH_MS_BASE_URL}/user/login", json=login_payload)
        login_response.raise_for_status()
        login_data = login_response.json()

        self.headers = {
            "Authorization": f"Bearer {login_data['token']}"
        }

    @task
    def add_product_to_cart(self):
        available_products = self.client.get(f"{PRODUCTS_MS_BASE_URL}/product")
        available_products.raise_for_status()
        self.selected_product = available_products.json()["products"][0]

        add_product_payload = {
            "product_id": self.selected_product["id"],
            "quantity": 1
        }
        response = self.client.post(f"{ORDERS_MS_BASE_URL}/cart", json=add_product_payload, headers=self.headers)
        response.raise_for_status()
        self.cart_item = response.json()

    @task
    def check_my_cart(self):
        response = self.client.get(f"{ORDERS_MS_BASE_URL}/cart", headers=self.headers)
        response.raise_for_status()

        cart_items = response.json()
        product_ids = [item["product_id"] for item in cart_items]
        if self.selected_product["id"] not in product_ids:
            raise Exception("The selected product is not found in the cart.")

    @task
    def create_order(self):
        create_order_payload = {
            "user": self.user_id,
            "shipping_provider": "JNE"
        }
        response = self.client.post(f"{ORDERS_MS_BASE_URL}/order", json=create_order_payload, headers=self.headers)
        response.raise_for_status()
        self.new_order = response.json()
        self.order_data = self.new_order["order"]

    @task
    def get_my_order_detail(self):
        response = self.client.get(f"{ORDERS_MS_BASE_URL}/order/{self.order_data['id']}", headers=self.headers)
        response.raise_for_status()
        self.my_order_detail = response.json()

    @task
    def pay_order(self):
        payload = {
            "payment_method": "QRIS",
            "payment_reference": str(uuid4()),
            "amount": self.order_data["total_amount"]
        }
        response = self.client.post(f"{ORDERS_MS_BASE_URL}/order/{self.order_data['id']}/pay", json=payload, headers=self.headers)
        response.raise_for_status()

class OrdersMicroserviceUser(HttpUser):
    host = ORDERS_MS_BASE_URL
    tasks = [TestScenario]
    wait_time = constant(1)  # constant think time between tasks

class ConstantUserShape(LoadTestShape):
    """
    Constant number of users for Fairness Testing.
    """
    stages = [
        {"duration": 600, "users": 1000, "spawn_rate": 10},  # 5 minutes at 1000 users
    ]

    def tick(self):
        run_time = self.get_run_time()

        for stage in self.stages:
            if run_time < stage["duration"]:
                return stage["users"], stage["spawn_rate"]

        return None
