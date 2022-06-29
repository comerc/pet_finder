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
CREATE TABLE public.category (
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
    display_name text,
    image_url text,
    phone text NOT NULL,
    is_whats_app boolean DEFAULT false NOT NULL,
    is_viber boolean DEFAULT false NOT NULL
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
    total_wishes integer DEFAULT 0 NOT NULL,
    category text NOT NULL
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
COPY public.age (value) FROM stdin;
child
adult
aged
\.
COPY public.category (value) FROM stdin;
cat
dog
\.
COPY public.color (id, created_at, updated_at, is_deleted, name) FROM stdin;
gray	2022-04-11 20:38:42.508322+00	2022-04-11 20:38:42.508322+00	f	Gray
white	2022-04-11 20:38:54.277005+00	2022-04-11 20:38:54.277005+00	f	White
black	2022-04-11 20:39:05.775317+00	2022-04-11 20:39:05.775317+00	f	Black
tiger	2022-04-11 20:39:18.001867+00	2022-04-11 20:39:18.001867+00	f	Tiger
stripe	2022-04-11 20:39:29.99037+00	2022-04-11 20:39:29.99037+00	f	Stripe
ginger	2022-04-11 20:42:05.063033+00	2022-04-11 20:42:05.063033+00	f	Ginger
siberian	2022-04-12 17:39:04.588798+00	2022-04-12 17:39:04.588798+00	f	Siberian
black_n_white	2022-04-12 17:35:29.155839+00	2022-04-12 17:39:17.120603+00	f	Black & White
multicolor	2022-04-12 17:46:50.549134+00	2022-04-12 17:46:50.549134+00	f	Multicolor
brown	2022-04-12 17:59:22.091774+00	2022-04-12 17:59:22.091774+00	f	Brown
golden	2022-04-12 18:26:51.131688+00	2022-04-12 18:26:51.131688+00	f	Golden
milky_coffee	2022-04-12 18:40:29.72127+00	2022-04-12 18:40:29.72127+00	f	Milky Coffee
ginger_n_white	2022-04-12 19:03:50.721095+00	2022-04-12 19:03:50.721095+00	f	Ginger & White
other	2022-04-12 19:21:32.205223+00	2022-04-12 19:21:32.205223+00	f	Other
\.
COPY public.member (id, created_at, updated_at, is_deleted, display_name, image_url, phone, is_whats_app, is_viber) FROM stdin;
f6536398-5fdd-48ca-adfa-06ad55a2c7cc	2022-04-11 20:32:15.757058+00	2022-04-11 20:32:15.757058+00	f	Andrew Ka	\N	7 (987) 654-32-10	f	f
\.
COPY public.sex (value) FROM stdin;
male
female
\.
COPY public.size (id, created_at, updated_at, is_deleted, name) FROM stdin;
tiny	2022-04-11 20:36:52.521993+00	2022-04-11 20:36:52.521993+00	f	Tiny
little	2022-04-11 20:37:19.643142+00	2022-04-11 20:37:19.643142+00	f	Little
middle	2022-04-11 20:37:33.680052+00	2022-04-11 20:37:33.680052+00	f	Middle
big	2022-04-11 20:37:45.829221+00	2022-04-11 20:37:45.829221+00	f	Big
huge	2022-04-11 20:37:59.714738+00	2022-04-11 20:37:59.714738+00	f	Huge
\.
COPY public.unit (id, created_at, updated_at, is_deleted, member_id, images, title, sex, birthday, age, weight, size_id, wool, color_id, story, phone, address, total_wishes, category) FROM stdin;
8532aeb6-16cd-45b1-b01e-d799f4a1742a	2022-04-12 17:28:27.287082+00	2022-04-12 17:28:27.287082+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F1febda55-7947-4cfd-815d-6963f6f38c38.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Ушастик	male	\N	adult	\N	little	normal	ginger	Lorem ipsum dolor sit amet consectetur adipisicing elit. Obcaecati magni facilis impedit dolorum, fuga nobis debitis eum iste maxime assumenda!	\N	Минск, Центральный р-н	0	cat
2e5aa50d-ba8b-4491-84b3-62999f643afa	2022-04-12 17:41:49.437341+00	2022-04-12 17:41:49.437341+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F2234c696-ad71-4984-93c3-8e3a7fa3f860.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Сибирская кошка	female	\N	adult	\N	middle	long	siberian	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias laudantium, ipsam quaerat distinctio magni molestias.	\N	Минск, Немига	0	cat
852cce09-c036-488c-b9a7-2a15153c24df	2022-04-12 17:47:28.57261+00	2022-04-12 17:47:28.57261+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F4050378e-bea9-4c3c-8875-afc857d11ae3.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Бордер-колли	male	\N	adult	\N	middle	long	multicolor	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias laudantium, ipsam quaerat distinctio magni molestias.	\N	Минск, м. Пушкинская	0	cat
b2c0f732-b567-45ea-9f86-54fe9610a026	2022-04-12 17:49:56.653817+00	2022-04-12 17:49:56.653817+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F759bd45a-e590-458e-94a7-6e6524806036.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Верный друг	male	\N	adult	\N	middle	long	ginger	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias laudantium, ipsam quaerat distinctio magni molestias.	\N	Минск, Шабаны	0	cat
6030d87c-d511-4839-a58a-9e79935352e5	2022-04-12 17:56:17.463015+00	2022-04-12 17:56:17.463015+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F7daf94ed-6c78-43ac-91cd-6a8fa909b88f.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Мини Рысь!	female	\N	child	\N	tiny	normal	multicolor	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias laudantium, ipsam quaerat distinctio magni molestias.	\N	Минск, м. Могилёвская	0	cat
cd577124-ea15-46c2-b1d9-f3bb780a330c	2022-04-12 18:00:57.935127+00	2022-04-12 18:00:57.935127+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2Fb0f13f7f-ec69-4fa1-a172-27b9a8fba1a8.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Шарик	male	\N	adult	\N	middle	normal	brown	Lorem ipsum dolor, sit amet consectetur adipisicing.	\N	Минск, м. Парк Челюскинцев	0	cat
1e3db6cf-520d-4b5b-86f4-acaa9393e7ca	2022-04-12 18:03:55.600618+00	2022-04-12 18:03:55.600618+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2Fc98b527a-0578-471b-9e19-f0f0ac19b7f2.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Охотник	male	\N	adult	\N	middle	long	white	Lorem ipsum dolor sit amet, consectetur adipisicing elit. Officia, iste.	\N	Минск, Веснянка	0	cat
c8581511-5b36-4b59-9a06-8258ae8caaef	2022-04-12 18:07:43.040477+00	2022-04-12 18:07:43.040477+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2Fe3ee2496-2090-4af7-a7c8-168de53a9138.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Тигрица	female	\N	adult	\N	middle	normal	tiger	Lorem ipsum dolor sit amet.	\N	а.г. Ждановичи	0	cat
5664c161-09fd-49b7-a9f8-ed94ce33f821	2022-04-12 18:32:26.724433+00	2022-04-12 18:32:26.724433+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F3bf496ec-a43e-4dfd-98b6-2740b46dae82.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 427, "height": 427}]	Ретривер	female	\N	adult	\N	big	normal	golden	Lorem ipsum dolor sit amet, consectetur adipisicing elit. Officia, iste.	\N	Минск, м. Молодёжная	0	cat
44028fa1-3314-45ed-9c0f-c22605d1a12b	2022-04-12 18:35:30.111555+00	2022-04-12 18:35:30.111555+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F8f8d6a4d-9239-4515-b87f-bc877d84b09b.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 427, "height": 427}]	Тотошка	female	\N	child	\N	little	short	multicolor	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias laudantium, ipsam quaerat distinctio magni molestias.	\N	Заславль	0	cat
4424365a-c38c-4c31-a829-890872ad880f	2022-04-12 18:41:21.291331+00	2022-04-12 18:41:21.291331+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2Fa32fec57-5e52-4c04-941c-83b1ca85c546.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 427, "height": 427}]	Умница	female	\N	adult	\N	middle	long	milky_coffee	Lorem ipsum dolor, sit amet consectetur adipisicing.	\N	Минск, Московский район	0	cat
6217ad56-f678-4c7f-90a6-f40e62b9acb4	2022-04-12 18:45:26.847533+00	2022-04-12 18:45:26.847533+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2Fc5dbfe8e-745e-409f-a0e7-f9fb045ba13a.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 427, "height": 427}]	Пуговка	female	\N	child	\N	tiny	long	siberian	Lorem ipsum dolor sit amet, consectetur adipisicing elit. Officia, iste.	\N	Минск, Ангарская ул.	0	cat
4e68ec3f-af43-477a-a6d1-d7cce0708d62	2022-04-12 18:48:13.816772+00	2022-04-12 18:48:13.816772+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2Fc84d8cb5-c402-45ec-8b02-795ddfa4ef72.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 427, "height": 427}]	Котопёс	male	\N	child	\N	tiny	short	gray	Lorem ipsum dolor sit amet.	\N	Тарасово	0	cat
8551cee7-cf80-45a1-bafe-86126fec0f9c	2022-04-12 17:24:35.006961+00	2022-04-12 19:24:44.069012+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F08df5992-b76f-4202-b390-892a6c69906f.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Рыжик	female	\N	adult	\N	middle	short	ginger	Lorem ipsum dolor sit amet, consectetur adipisicing elit. Officia, iste.	\N	Минск, Советский р-н	0	cat
6e068eca-ea00-4c7c-8f72-54876bd1d415	2022-04-11 20:43:47.309606+00	2022-04-12 19:25:14.294431+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F0448db8b-9fad-409e-a224-ada571573464.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Кучеряшка	female	\N	child	\N	tiny	normal	ginger	 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Officia, iste.	\N	Минск, центр	0	cat
667f7ab5-0d92-4a33-a0e7-04249e772e80	2022-04-12 18:51:53.30618+00	2022-04-12 18:51:53.30618+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2Ff753e958-0d80-4cec-8236-52db666f8512.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 427, "height": 427}]	Тигр комнатный	male	\N	adult	\N	middle	short	tiger	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias laudantium, ipsam quaerat distinctio magni molestias.	\N	Малиновка	0	cat
0302e5db-a425-4eec-b1a5-30936be9a475	2022-04-12 18:54:18.554432+00	2022-04-12 18:54:18.554432+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2Fdbab6c45-f1a4-4f8a-b1bf-a8851104db34.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 449, "height": 449}]	Красотулька	female	\N	adult	\N	middle	short	multicolor	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias laudantium, ipsam quaerat distinctio magni molestias.	\N	Сеница	0	cat
c5191749-6c5e-48f6-8bef-9dbae7f61bf0	2022-04-12 18:56:56.725804+00	2022-04-12 18:56:56.725804+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F15d29599-5087-4cc9-b766-ee670225d7f1.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 462, "height": 462}]	Муся	female	\N	child	\N	tiny	long	multicolor	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Alias laudantium, ipsam quaerat distinctio magni molestias.	\N	Цнянка	0	cat
3ce67a0a-e3a9-43f1-b20c-dd9e57c58bfc	2022-04-12 19:01:22.341173+00	2022-04-12 19:01:22.341173+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F2f56fc11-f583-40f6-8096-0be3a4eabd0f.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 623, "height": 623}]	Дружок	male	\N	adult	\N	big	normal	ginger	Lorem ipsum dolor sit amet consectetur, adipisicing elit. Similique amet quibusdam blanditiis maxime provident ad vitae esse excepturi culpa iusto, magnam earum neque nulla! Dolores non blanditiis soluta nulla consequatur nisi minus, sit pariatur odit? Voluptatem et ducimus repellendus sit odio illum culpa natus odit. Magnam porro architecto labore quaerat!	\N	Валерьяново	0	cat
512996c4-f522-4a8b-9f07-1b1fc4224f3a	2022-04-12 19:07:25.176218+00	2022-04-12 19:07:25.176218+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F5f0266a0-f70c-403f-b84e-3d6b8823f3be.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 480, "height": 480}]	Яша	male	\N	adult	\N	middle	short	ginger_n_white	Lorem ipsum, dolor sit amet consectetur adipisicing elit. Sunt deserunt cum repellendus hic ad nostrum! Odit culpa labore ipsam atque dolor officiis laudantium suscipit voluptatum nam dolore consequatur fuga natus obcaecati necessitatibus libero quisquam incidunt quam assumenda, aperiam repudiandae dicta. Dolore eveniet ab error! Molestiae vel veniam odio enim. Totam facilis dolores tempora quam delectus asperiores facere animi soluta laborum blanditiis eos natus quia aut est ratione dignissimos, molestias, commodi alias dolore. Sapiente dolorum quidem mollitia laboriosam voluptates quam unde atque neque, minima, consequatur sequi aspernatur repellat consectetur et sed esse, quisquam qui harum cumque deleniti. Debitis labore quo adipisci.	\N	Новый Двор	0	cat
e120e325-6359-457f-8298-485e27294126	2022-04-12 17:36:45.91958+00	2022-04-12 19:22:42.776432+00	f	f6536398-5fdd-48ca-adfa-06ad55a2c7cc	[{"url": "https://firebasestorage.googleapis.com/v0/b/pet-finder-1703.appspot.com/o/images%2F33f7079a-db78-4a7e-8ca7-3aeec1e7eee6.png?alt=media&token=e2e93236-d03b-4e36-aca3-89b17d8b5ed4", "width": 640, "height": 640}]	Самая умная порода	male	\N	adult	\N	middle	long	black_n_white	Lorem ipsum dolor sit amet consectetur adipisicing elit. Officiis, voluptates?	\N	Минск, Каменная Горка	0	cat
\.
COPY public.wish (member_id, unit_id, created_at, updated_at, value) FROM stdin;
\.
COPY public.wool (value) FROM stdin;
short
normal
long
\.
ALTER TABLE ONLY public.age
    ADD CONSTRAINT age_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (value);
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
    ADD CONSTRAINT unit_category_fkey FOREIGN KEY (category) REFERENCES public.category(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
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
