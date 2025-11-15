-- This script is idempotent and can be run multiple times safely.

-- 1. Create the users table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.users (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    email CHARACTER VARYING,
    phone CHARACTER VARYING,
    governorate CHARACTER VARYING,
    city CHARACTER VARYING,
    street CHARACTER VARYING,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    user_id UUID NULL,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email),
    CONSTRAINT users_phone_key UNIQUE (phone),
    CONSTRAINT users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE
);

-- 2. Alter existing table to allow NULL values for profile columns
-- This is the key fix: it allows the trigger to insert a row with only user_id and email.
ALTER TABLE public.users ALTER COLUMN phone DROP NOT NULL;
ALTER TABLE public.users ALTER COLUMN governorate DROP NOT NULL;
ALTER TABLE public.users ALTER COLUMN city DROP NOT NULL;
ALTER TABLE public.users ALTER COLUMN street DROP NOT NULL;

-- 3. Drop existing objects to ensure the script can be re-run without errors
DROP POLICY IF EXISTS "Allow individual read access" ON public.users;
DROP POLICY IF EXISTS "Allow individual update access" ON public.users;
DROP POLICY IF EXISTS "Allow individual delete access" ON public.users;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- 4. Enable Row Level Security on the users table
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- 5. Create the function that inserts a new user profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (user_id, email, phone, governorate, city, street)
  VALUES (
    new.id,
    new.email,
    new.raw_user_meta_data->>'phone',
    new.raw_user_meta_data->>'governorate',
    new.raw_user_meta_data->>'city',
    new.raw_user_meta_data->>'street'
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Create the trigger to call the function on new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- 7. Recreate RLS policies
CREATE POLICY "Allow individual read access" ON public.users
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Allow individual update access" ON public.users
FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow individual delete access" ON public.users
FOR DELETE
USING (auth.uid() = user_id);
