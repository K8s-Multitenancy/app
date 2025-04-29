import random
from uuid import uuid4
from locust import HttpUser, LoadTestShape, SequentialTaskSet, constant, task
from config import AUTH_MS_BASE_URL, ORDERS_MS_BASE_URL, PRODUCTS_MS_BASE_URL
from utils.formatCSVShapeData import formatCSVShapeData

class TestScenario(SequentialTaskSet):
    def on_start(self):
        """Executed once at the start, not recorded in report."""
        self.preparation()

    # @task
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
        register_data = register_response.json()
        self.user_id = register_data[0]["id"]  # TODO: CHANGE THE "id" KEY TO PROPER KEY FROM RESPONSE IF ERROR

        # Login
        login_payload = {
            "username": register_payload["username"],
            "password": register_payload["password"]
        }
        login_response = self.client.post(f"{AUTH_MS_BASE_URL}/user/login", json=login_payload)
        login_data = login_response.json()

        self.headers = {
            "Authorization": f"Bearer {login_data['token']}"
        }

    @task
    def get_all_available_product(self):
        available_products = self.client.get(f"{PRODUCTS_MS_BASE_URL}/product")
        if available_products.status_code == 200:
            self.available_products = available_products.json()
        else:
            print(f"Failed to get available products, status code: {available_products.status_code}")
            self.available_products = {"products": []}  # fallback to empty list

    @task
    def add_product_to_cart(self):
        # available_products = self.client.get(f"{PRODUCTS_MS_BASE_URL}/product")
        self.selected_product = self.available_products["products"][0]
        add_product_payload = {
            "product_id": self.selected_product["id"],
            "quantity": 1
        }
        response = self.client.post(f"{ORDERS_MS_BASE_URL}/cart", json=add_product_payload, headers=self.headers)
        if response.status_code != 201:
            raise Exception("Failed to add items to cart")
        self.cart_item = response.json()

    @task
    def check_my_cart(self):
        response = self.client.get(f"{ORDERS_MS_BASE_URL}/cart", headers=self.headers)
        if response.status_code != 200:
            raise Exception("Error in checking my cart")
        
        cart_items = response.json()
        product_ids = [item["product_id"] for item in cart_items]

        if self.selected_product["id"] not in product_ids:
            raise Exception("The selected product is not in the cart.")

    @task
    def create_order(self):
        create_order_payload = {
                "user": self.user_id,
                "shipping_provider": "JNE"
            }
        response = self.client.post(f"{ORDERS_MS_BASE_URL}/order", json=create_order_payload, headers=self.headers)
        
        if response.status_code != 201:
            raise Exception("Failed to create new order")
        self.new_order = response.json()
        self.order_data = self.new_order["order"]

    @task
    def get_my_order_detail(self):
        response = self.client.get(f"{ORDERS_MS_BASE_URL}/order/{self.order_data['id']}", headers=self.headers)
        if response.status_code != 200:
            raise Exception("Error in getting my order's detail")
        self.my_order_detail = response.json()

    @task
    def pay_order(self):
        payload = {
            "payment_method": "QRIS",
            "payment_reference": str(uuid4()),
            "amount": self.order_data['total_amount']
        }
        response = self.client.post(f"{ORDERS_MS_BASE_URL}/order/{self.order_data['id']}/pay", json=payload, headers=self.headers)
        if response.status_code != 200:
            raise Exception("Error in paying my order")

class OrdersMicroserviceUser(HttpUser):
    host = ORDERS_MS_BASE_URL
    tasks = [TestScenario]
    wait_time = constant(1)

class PoissonShapeOrders(LoadTestShape):
    stages = formatCSVShapeData(
        'shape/poisson_max_1000.csv',
        OrdersMicroserviceUser
    )
    def tick(self):
        run_time = self.get_run_time()

        for stage in self.stages:
            if run_time < stage["duration"]:
                try:
                    tick_data = (stage["users"], stage["spawn_rate"], stage["user_classes"])
                except:
                    tick_data = (stage["users"], stage["spawn_rate"])
                return tick_data

        return None


def generate_random_phone_number():
    prefix = random.choice(["0812", "0813", "0821", "0857", "0878"])
    number = ''.join(random.choices("0123456789", k=8))
    return prefix + number