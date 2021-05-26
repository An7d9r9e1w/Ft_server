#docker rm -f ft_server1
#docker rmi ft_server
docker build -t ft_server:latest ./
docker run -d --name ft_server1 -p 80:80 -p 443:443 ft_server:latest
#docker exec -it ft_server1 bash
