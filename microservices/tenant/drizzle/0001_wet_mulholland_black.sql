ALTER TABLE "tenantDetails" DROP CONSTRAINT "tenantDetails_tenant_id_tenants_id_fk";
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "tenantDetails" ADD CONSTRAINT "tenantDetails_tenant_id_tenants_id_fk" FOREIGN KEY ("tenant_id") REFERENCES "tenants"("id") ON DELETE no action ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
