# Boardgame Store Scraper

A Ruby codebase for scraping boardgame store listings and exporting the results to CSV files.
These CSVs are later uploaded into a separate Rails web application (maintained in another repository).

## Overview

This project uses [Tanakai](https://github.com/glaucocustodio/tanakai/) (a Ruby web scraping framework) to define spiders for different online boardgame stores.

- Scraping: Each spider is responsible for fetching and parsing store listings.
- Output: Results are saved as .csv files for further processing.
- Integration: The CSV files are manually uploaded into a Rails application that handles display, filtering, and user interaction.

## Testing

- [RSpec](https://github.com/rspec/rspec) is used for unit and integration testing
- [WebMock](https://github.com/webmock/webmock) is used to stub external requests, ensuring deterministic and fast tests.

## Current Limitations

- The scraper design is tightly coupled to the Tanakai framework.
  - Spiders rely on Tanakai’s class-method-based structure.
  - Code invocation feels less modular and flexible than desired.
- Data export and upload are manual (run the scraper locally, then upload CSVs to the Rails app).

## Roadmap

1. Refactor Scraper Architecture

   - Separation of concerns
     - Spiders: handle navigation and request scheduling.
     - Parsers: handle HTML parsing, object construction, and data normalization.
   - Index vs. Show Parsers
     - Support for configurable parsers (selectors defined via config instead of hard-coded logic) to make them reusable across stores.
     - Define a consistent pattern where each store has:
       - Index parser for product listings (/products?page=1).
       - Show parser for product detail pages (/products/:id).

2. Easier Invocation & Automation

   - Move from the Tanakai invoke command (`bundle exec tanakai crawl spider_name`) to a more simpler, unified runner.
   - Expose the scraper as a Ruby API (not just a CLI command) so it can be triggered from scripts, CI/CD pipelines, or scheduled jobs.

3. Data Storage & Export

   - Move away from writing raw CSVs during scraping.
   - Store results in a SQLite database by default (structured, queryable, more reliable).
   - Provide flexible exporters:
     - CSV exporter: generate CSVs when needed for manual workflows.
     - HTTP uploader: read from SQLite and POST data directly to the Rails app.

4. Observability & Resilience

   - Improve error handling to detect and report:
     - Spider crashes (e.g. network or parsing errors).
     - Store markup changes (e.g. missing selectors, unexpected DOM).
   - Logging & monitoring:
     - Structured logs (JSON or tagged text logs).
     - Summary reports after each run (e.g. number of products scraped, failures, skipped entries).
   - Notifications when something breaks (email, Slack, etc.).

5. Scalability & Workflow Enhancements
   - Support scheduled runs (cron, systemd timers, or CI jobs).
   - Prepare for a queue/job system to allow concurrent scraping and scaling across multiple stores.

## Getting Started

### Prerequisites

- Ruby (≥ 3.4)
- Bundler

### Setup

```sh
git clone https://github.com/nico-or/turnoextra_spiders.git
cd turnoextra_spiders
bundle install
```

### Running all Spiders

```sh
rake runner

# The scraped results will be written to /db/YYYYMMDD_spider_name.csv
```

### Running a single Spider

```sh
# Example: run a specific store spider
bundle exec tanakai crawl spider_name

# The scraped results will be written to /db/YYYYMMDD_spider_name.csv
```

### Running Tests

```sh
bundle exec rspec
```

## Project Structure

```
.
├── config/                 # Configuration and boot files
├── pipelines/              # Item processing classes
├── spiders/                # Individual store spiders (Tanakai-based classes)
│   └── ecommerce_engines/  # Common ecommerce engine behaviour
├── db/                     # Generated CSV files
├── log/                    # Generated log files
├── spec/                   # RSpec test suite
├── Gemfile                 # Ruby dependencies
└── README.md
```
