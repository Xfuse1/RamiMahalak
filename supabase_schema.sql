-- Idempotent users profile schema and trigger
-- Run once in Supabase SQL Editor or via migrations

-- 1) Users table keyed by auth.users.id
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY,
  email TEXT NULL,
  phone TEXT NULL,
  governorate TEXT NULL,
  city TEXT NULL,
  street TEXT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Ensure columns exist in case table was created earlier with fewer fields
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS email TEXT NULL;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS phone TEXT NULL;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS governorate TEXT NULL;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS city TEXT NULL;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS street TEXT NULL;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT now();

-- Ensure FK to auth.users(id)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint c
    JOIN pg_class t ON t.oid = c.conrelid
    WHERE t.relname = 'users' AND c.contype = 'f'
  ) THEN
    ALTER TABLE public.users
      ADD CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
  END IF;
END$$;

-- 2) Drop/recreate programmable objects
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- 3) Function to copy metadata from auth to public.users on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, phone, governorate, city, street)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'phone',
    NEW.raw_user_meta_data->>'governorate',
    NEW.raw_user_meta_data->>'city',
    NEW.raw_user_meta_data->>'street'
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    governorate = EXCLUDED.governorate,
    city = EXCLUDED.city,
    street = EXCLUDED.street,
    updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4) Trigger
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- 5) RLS policies
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "users_select_own" ON public.users;
DROP POLICY IF EXISTS "users_update_own" ON public.users;
DROP POLICY IF EXISTS "users_delete_own" ON public.users;

CREATE POLICY "users_select_own" ON public.users
FOR SELECT USING (auth.uid() = id);

CREATE POLICY "users_update_own" ON public.users
FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY "users_delete_own" ON public.users
FOR DELETE USING (auth.uid() = id);

-- 6) Helper function to look up email by normalized phone
--    This is used by the Flutter app to allow login with phone OR email
--    for the same underlying auth user.
CREATE OR REPLACE FUNCTION public.get_email_by_phone(p_phone TEXT)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = auth, public
AS $$
DECLARE
  v_email TEXT;
BEGIN
  SELECT u.email
  INTO v_email
  FROM auth.users AS u
  WHERE u.raw_user_meta_data->>'phone' = p_phone
  LIMIT 1;

  RETURN v_email;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_email_by_phone(TEXT) TO anon;
