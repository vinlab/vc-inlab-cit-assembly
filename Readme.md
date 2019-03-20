# Code Inventory Assembly

## Usage

Start Code Inventory (as daemon): `./start.sh`

Stop Code Inventory, started as daemon: `./stop.sh`

### Verification/Troubleshooting

Follow Code Inventory logs when started as daemon: 
* Backend: `docker logs -f docker_code_inventory_backend-app_1`
* Database: `docker logs -f docker_code_inventory_backend-postgresql_1`
* Grafana: `docker logs -f docker_code_inventory-grafana_1`

Run Code Inventory as non-daemon and see all logs: `./start+logs.sh`
