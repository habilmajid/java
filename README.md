# Zanzibar Smart School System | C++ Web App

Mfumo wa majaribio (MVP) uliotengenezwa kwa **C++17, Boost.Beast, Boost.JSON, SQLite na PostgreSQL**. Una website yenye Kiswahili na C++ server inayoihudumia. Ni mradi wa kujifunzia wa mwanafunzi, **si mfumo wa uzalishaji wa shule**.

## Vipengele vilivyojengwa tayari

- Admin login / logout kwa cookie ya HttpOnly + SameSite=Strict.
- Sajili, angalia, tafuta na futa **wanafunzi** na **walimu**.
- Rekodi na angalia **matokeo** (alama 0-100), **kumbukumbu za ada** (si kuchakata malipo), na **ratiba**.
- Dashibodi ya takwimu, matokeo na jumla ya ada zilizorekodiwa.
- SQLite kwa majaribio ya kompyuta; Neon PostgreSQL kwa hosting inayohitaji kuhifadhi data baada ya restart.
- Dockerfile na `render.yaml` kwa Render Free.
- Database queries zinatumia parameters; password zinahifadhiwa kwa PBKDF2-HMAC-SHA256 + salt, si plain text.

## Muhimu kuhusu XAMPP

**Huhitaji XAMPP au MySQL ili kuanza mradi huu.** C++ server inafunguka kwa `http://localhost:8080` yenyewe. Apache ya XAMPP inaweza kuwashwa au kuzimwa; haitazuia port 8080 ikiwa haijatumika. SQLite hutengeneza faili `data/school.db` yenyewe. Hii ni njia nzuri wakati MySQL ya XAMPP haikubali kuwaka.

## 1) Kuendesha kwenye Windows 10/11

Tazama [docs/WINDOWS_XAMPP.md](docs/WINDOWS_XAMPP.md) kwa hatua zenye maelezo zaidi. Muhtasari:

1. Install **MSYS2** kutoka https://www.msys2.org/ na fungua **MSYS2 UCRT64** terminal.
2. Install vifaa vya C++:

   ```bash
   pacman -Syu
   # Ikikuomba ufunge terminal, fungua UCRT64 tena, kisha endelea:
   pacman -S --needed mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-ninja mingw-w64-ucrt-x86_64-boost mingw-w64-ucrt-x86_64-sqlite3 mingw-w64-ucrt-x86_64-openssl
   ```

3. Extract ZIP, fungua terminal kwenye folder ya project, kisha:

   ```bash
   cmake -S . -B build -G Ninja
   cmake --build build
   export ADMIN_EMAIL="admin@example.test"
   export ADMIN_PASSWORD="BadilishaNenosiriLako123!"
   export DEMO_SEED=1
   ./build/school_server.exe
   ```

4. Fungua browser: **http://localhost:8080**. Ingia kwa email na password uliyoweka hapo juu.

Password lazima iwe na angalau herufi 12. Mifano iliyo kwenye README ni kwa kujifunzia tu; kwa hosting tumia password yako mpya na ya kipekee.

## 2) Kuendesha kwenye Linux (kwa developers)

Unahitaji C++17, CMake, Boost 1.83+, SQLite dev, OpenSSL dev, na kwa PostgreSQL `libpq-dev`:

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j2
export ADMIN_EMAIL="admin@example.test"
export ADMIN_PASSWORD="BadilishaNenosiriLako123!"
export DEMO_SEED=1
./build/school_server
```

Programu hutengeneza `data/school.db` kiotomatiki. Hifadhi folder hilo kama unataka data zako za majaribio zibaki.

### Smoke test

```bash
python3 scripts/test_smoke.py
```

Jaribio linaanzisha C++ server kwa SQLite database ya muda, na hukagua authentication, CRUD na takwimu.

## 3) Hosting ya bure: Render + Neon

**Soma [docs/HOSTING_RENDER_NEON.md](docs/HOSTING_RENDER_NEON.md)** kwa hatua kamili. Kifupi:

1. Tengeneza Neon PostgreSQL database kwenye https://neon.com (Free plan), copy PostgreSQL connection string yenye `sslmode=require`.
2. Peleka folder yote ya project (si ZIP moja tu) kwenye GitHub repo yako.
3. Kwenye https://render.com, tengeneza **Web Service** kutoka GitHub repo, chagua **Docker** na plan **Free**.
4. Set Environment Variables hizi:
   - `DATABASE_URL` = connection string yako ya Neon (iweke kwa siri)
   - `ADMIN_EMAIL` = email yako ya admin
   - `ADMIN_PASSWORD` = password ya kipekee (herufi 12+)
   - `COOKIE_SECURE` = `1`
   - `DEMO_SEED` = `0` (au `1` tu kuingiza taarifa za mfano)
5. Deploy. Fungua URL inayoishia `.onrender.com` na uingie.

### Kwa nini Neon badala ya SQLite wakati wa Render Free?

Render Free haina persistent disk. Ukiweka SQLite peke yake kwenye server ya Render Free, data zinaweza kupotea server inapojianzisha upya au wakati wa redeploy. Neon huhifadhi database nje ya server. Render Free hulala baada ya kukaa bila traffic, na free plan ina limits. Hizi ni huduma za majaribio, si hosting ya uhakika wa uzalishaji.

## Mipaka ya toleo hili (lazima ujue)

- Admin **mmoja tu** kwa sasa; hakuna teacher/student logins, password reset UI, au ugawaji wa majukumu.
- Ada ni **kumbukumbu za mfano tu**, si mfumo wa kutoa risiti halali au kupokea fedha.
- Hakuna automatic backups, audit log, edit forms, bulk CSV import, wala viwango vya production availability.
- Sessions zipo kwenye kumbukumbu ya server na huisha baada ya saa 8 au server ikirestart.
- Usiingize data halisi za wanafunzi, matokeo binafsi, taarifa za mawasiliano, au malipo kabla ya kufanya ukaguzi wa usalama, idhini, na usimamizi wa taarifa hizo.
- Mtandao unahitaji HTTPS. Render hutumia HTTPS kwa anwani yake ya kawaida; `COOKIE_SECURE=1` ni muhimu ukiwa umehost.

## Muundo wa mradi

```
ZanzibarSmartSchoolSystem/
├── CMakeLists.txt           # C++ build
├── Dockerfile               # Build/run katika Render
├── render.yaml              # Optional Render Blueprint
├── src/
│   ├── main.cpp             # HTTP server, API, login, sessions
│   ├── database.cpp         # SQLite / PostgreSQL abstraction
│   ├── database.hpp
│   └── json_impl.cpp        # Boost.JSON implementation
├── public/
│   ├── index.html           # Frontend HTML
│   ├── styles.css           # Responsive UI
│   ├── app.js               # Frontend interactions
│   └── favicon.svg
├── scripts/test_smoke.py    # Automated API integration test
└── docs/
    ├── WINDOWS_XAMPP.md
    ├── HOSTING_RENDER_NEON.md
    └── API.md
```

## Vyanzo vya huduma

- Render Free hosting: https://render.com/docs/free
- Render first deploy: https://render.com/docs/your-first-deploy
- Neon: https://neon.com
- MSYS2: https://www.msys2.org/

© 2026. Demo source for learning, MIT License.
