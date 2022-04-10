SET check_function_bodies = false;
CREATE FUNCTION public.after_insert_wish() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE _one INTEGER;
BEGIN
  IF NEW.value THEN
    _one := 1;
  ELSE
    _one := -1;
  END IF;
  UPDATE unit SET total_wishes = total_wishes + _one WHERE id = NEW.unit_id;
  RETURN NEW;
END;
$$;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.age (
    value text NOT NULL
);
CREATE TABLE public.color (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    name text NOT NULL
);
CREATE TABLE public.member (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    display_name text NOT NULL,
    image_url text NOT NULL,
    phone text NOT NULL,
    is_whatsapp boolean NOT NULL,
    is_viber boolean NOT NULL
);
CREATE TABLE public.sex (
    value text NOT NULL
);
CREATE TABLE public.size (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    name text NOT NULL
);
CREATE TABLE public.unit (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    member_id uuid NOT NULL,
    images jsonb NOT NULL,
    title text NOT NULL,
    sex text NOT NULL,
    birthday date,
    age text NOT NULL,
    weight integer,
    size_id text NOT NULL,
    wool text NOT NULL,
    color_id text NOT NULL,
    story text NOT NULL,
    phone text,
    address text NOT NULL,
    total_wishes integer DEFAULT 0 NOT NULL
);
CREATE TABLE public.wish (
    member_id uuid NOT NULL,
    unit_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    value boolean DEFAULT true NOT NULL
);
CREATE TABLE public.wool (
    value text NOT NULL
);
ALTER TABLE ONLY public.age
    ADD CONSTRAINT age_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.color
    ADD CONSTRAINT color_name_key UNIQUE (name);
ALTER TABLE ONLY public.color
    ADD CONSTRAINT color_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sex
    ADD CONSTRAINT sex_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.size
    ADD CONSTRAINT size_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.wish
    ADD CONSTRAINT wish_pkey PRIMARY KEY (member_id, unit_id);
ALTER TABLE ONLY public.wool
    ADD CONSTRAINT wool_pkey PRIMARY KEY (value);
CREATE TRIGGER after_insert_wish AFTER INSERT ON public.wish FOR EACH ROW EXECUTE FUNCTION public.after_insert_wish();
CREATE TRIGGER set_public_color_updated_at BEFORE UPDATE ON public.color FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_color_updated_at ON public.color IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_member_updated_at BEFORE UPDATE ON public.member FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_member_updated_at ON public.member IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_size_updated_at BEFORE UPDATE ON public.size FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_size_updated_at ON public.size IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_unit_updated_at BEFORE UPDATE ON public.unit FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_unit_updated_at ON public.unit IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_wish_updated_at BEFORE UPDATE ON public.wish FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_wish_updated_at ON public.wish IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_age_fkey FOREIGN KEY (age) REFERENCES public.age(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_color_id_fkey FOREIGN KEY (color_id) REFERENCES public.color(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.member(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_sex_fkey FOREIGN KEY (sex) REFERENCES public.sex(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_size_id_fkey FOREIGN KEY (size_id) REFERENCES public.size(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_wool_fkey FOREIGN KEY (wool) REFERENCES public.wool(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.wish
    ADD CONSTRAINT wish_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.member(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.wish
    ADD CONSTRAINT wish_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.unit(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
