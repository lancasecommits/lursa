# Lursa: Plataforma Web para Gestão de Descarte de Lixo Eletrônico

> A web platform for managing electronic waste disposal in residential condominiums. Residents earn points for each correct disposal and redeem them for rewards. Building managers handle collection points, the product catalog, and the blog through an admin panel. Developed as a Capstone Project for the **Systems Analysis and Development** program at **Senac College**.

[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Senac](https://img.shields.io/badge/Institution-Senac%20College-blue)](https://www.senac.br/)
[![LGPD](https://img.shields.io/badge/Compliance-LGPD%20Ready-blueviolet)](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)

---

## Project Overview

**Lursa** is a smart waste management platform designed to improve electronic waste disposal in residential condominiums. Residents accumulate points by using registered collection points and can redeem them for products in the catalog. Administrators manage collection points on an interactive map, publish blog posts, and handle the rewards catalog through a dedicated admin panel.

### Key Features

* **QR Code Disposal Flow:** Residents scan a QR Code at a physical collection point, confirm the disposal on their phone, and receive points instantly — no manual input required.
* **Points & Rewards System:** Residents earn $L points per disposal and redeem them for products in the catalog, creating a gamified incentive loop for correct e-waste behavior.
* **Interactive Collection Map:** Leaflet.js + OpenStreetMap map showing all registered disposal points with address and points-per-disposal info — no API key required.
* **Admin Panel:** Full management of users, collection points, products, and blog posts from a dedicated dashboard.
* **Informational Blog:** Posts about recycling and sustainability, readable by anyone without login.

---

## LGPD & Data Privacy Compliance

Because this application processes **personal data** from residents (name, email, and disposal/redemption history), privacy by design was a core requirement of this project in compliance with Brazilian Federal Law nº 13.709/2018 (LGPD).

### Implemented Privacy Standards

* **Legal Basis for Processing (Art. 7º):** Data is only collected upon voluntary registration, establishing explicit consent as the legal basis for processing.
* **Data Minimization (Art. 6º, III):** Only data strictly necessary for the platform's operation is stored — name, email, password hash, points balance, and transactional history.
* **Security (Art. 46):** Passwords are hashed with bcrypt and never stored in plaintext. The session secret is loaded exclusively from environment variables, never hardcoded.
* **Right to Erasure (Art. 18, VI):** Administrators can permanently delete user accounts through the admin panel, removing all associated personal records.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Ruby 3.x + Sinatra |
| Database | SQLite 3 + Sequel ORM |
| Frontend | ERB templates + custom CSS |
| Map | Leaflet.js + OpenStreetMap |
| Auth | bcrypt + Rack sessions |
| Environment | dotenv |

---

## Getting Started

### Prerequisites

* [Ruby](https://www.ruby-lang.org/) 3.0+
* [Bundler](https://bundler.io/)

### 1. Clone the repository

```bash
git clone https://github.com/lancasecommits/lursa-api.git
cd lursa-api
```

### 2. Set up environment variables

```bash
cp .env.example .env
```

Edit `.env` with your values:

```env
SESSION_SECRET=a_long_random_secure_string
ADMIN_EMAIL=admin@lursa.com
ADMIN_PASSWORD=your_secure_password
```

### 3. Install dependencies

```bash
bundle install
```

### 4. Start the server

```bash
# Localhost only
ruby app.rb

# Accessible on local network (e.g. for mobile testing)
ruby app.rb -o 0.0.0.0
```

Open `http://localhost:4567` in your browser.

---

## API Routes

| Method | Route | Description | Auth |
|--------|-------|-------------|------|
| GET | `/` | Home — featured posts and products | — |
| GET | `/blog` | Blog post listing | — |
| GET | `/blog/:id` | Single blog post | — |
| GET | `/catalog` | Rewards catalog | — |
| POST | `/catalog/:id/redeem` | Redeem a product | User |
| GET | `/points` | Collection points map | — |
| GET | `/discard/:token` | Disposal confirmation screen | — |
| POST | `/discard/:token` | Register a disposal and credit points | User |
| GET | `/discard/:token/done` | Disposal success screen | User |
| GET | `/profile` | Authenticated user profile | User |
| GET | `/admin` | Admin dashboard | Admin |
| POST | `/admin/posts` | Create a blog post | Admin |
| DELETE | `/admin/posts/:id` | Delete a blog post | Admin |
| POST | `/admin/products` | Create a catalog product | Admin |
| DELETE | `/admin/products/:id` | Delete a catalog product | Admin |
| POST | `/admin/points` | Register a collection point | Admin |
| DELETE | `/admin/points/:id` | Delete a collection point | Admin |
| GET | `/admin/users` | List all users | Admin |
| POST | `/admin/users/:id/points` | Manually add points to a user | Admin |

---

## Project Structure

```
lursa-api/
├── app.rb                  # Entry point — session config, helpers, route loading
├── db.rb                   # Database schema and admin seed
├── models/
│   └── user.rb             # User model with bcrypt authentication
├── routes/
│   ├── public.rb           # Public routes (home, blog, catalog, map)
│   ├── auth.rb             # Login, signup, logout
│   ├── profile.rb          # User profile and product redemption
│   ├── discard.rb          # QR Code disposal flow
│   └── admin.rb            # Admin panel (users, points, products, posts)
├── views/
│   ├── layout.erb          # Base HTML layout
│   ├── shared/
│   │   └── _navbar.erb     # Bottom navigation bar
│   ├── index.erb           # Home page
│   ├── blog.erb            # Blog listing
│   ├── post.erb            # Single post
│   ├── catalog.erb         # Rewards catalog
│   ├── points.erb          # Collection points map
│   ├── discard.erb         # Disposal confirmation
│   ├── discard_done.erb    # Disposal success
│   ├── profile.erb         # User profile
│   ├── admin.erb           # Admin dashboard
│   ├── admin_users.erb     # User management
│   ├── new_point.erb       # Add collection point form
│   ├── new_product.erb     # Add product form
│   └── new_post.erb        # Add blog post form
└── public/
    └── css/
        ├── base.css        # Reset, layout, typography, utilities
        ├── components.css  # Navbar, cards, buttons, inputs, badges
        ├── home.css        # Home, blog, map, catalog sections
        ├── admin.css       # Admin panel and user table
        └── discard.css     # Disposal confirmation and success screens
```

---

## Future Improvements

* **Donor Leaderboard:** Ranking of top contributors by points to increase the competitive gamification element.
* **Environmental Impact Report:** Estimated CO₂ and heavy metal diversion metrics based on registered disposal volume.
* **Push Notifications:** Remind residents about nearby collection points or new products in the catalog.
* **Reverse Logistics Integration:** Connect with certified e-waste recycling partners to track the destination of collected materials.
* **PostgreSQL Migration:** Replace SQLite with PostgreSQL for production-grade concurrency support.

---

## Authors

* Beatriz Melo Lanteuil — `UI/UX` — [GitHub]()
* Bruno Lourenço — `Frontend` — [GitHub]()
* João Gabriel Dornelas — `Product Owner` — [GitHub]()
* Gabriel Victor — `Frontend` — [GitHub]()
* Gustavo Lins de Santana Macedo — `Backend` — [GitHub]() · [LinkedIn]()
* Leonardo Sales — `Backend` — [GitHub]() · [LinkedIn]()

---

Academic Advisor: Prof. ____________
Tech English Professor: Prof. Leonardo Trevas
