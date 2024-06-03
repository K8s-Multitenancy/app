import { NewUser } from "@db/schema/users";
import * as schema from '@db/schema/users'
import { db } from "@src/db";

export const insertNewUser = async (data: NewUser) => {
    const result = await db
                    .insert(schema.users)
                    .values(data)
                    .returning({
                        id: schema.users.id,
                        username: schema.users.username,
                        email: schema.users.email,
                        full_name: schema.users.full_name,
                        address: schema.users.address,
                        phone_number: schema.users.phone_number
                    })
    return result;
}