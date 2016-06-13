Highly Availeble Mongo
Replication and Clustering

3 config servers
2 Routers
N Sharded replicating clusters per DB

Base mode:
3:2:3

Scale mode:
3:2:N

For each N (sharded relicating node)
1) Create new EC2 with Docker
2) Run 2 mongod's, 1 mongo configdb, and 1 router and inform consul
3) Notify primary about additional replica

createShardableMongo --hostcount=2 --environment docker

