# ElixirMonitoringProm: Prometheus, PostGIS and Phoenix

- https://akoutmos.com/post/prometheus-postgis-and-phoenix/
- https://akoutmos.com/post/prometheus-postgis-and-phoenix-two/

## Setup and run

    docker-compose up
    # Visit http://localhost:3000 (admin/admin)
    curl -s -X GET "http://localhost:4000/api/breweries?zip_code=98052&mile_radius=4" | json
    elixir stress_test.exs