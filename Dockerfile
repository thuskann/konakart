FROM java:8
WORKDIR ~/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install apt-utils
RUN echo mysql-server mysql-server/root_password select l3tm31n | debconf-set-selections
RUN echo mysql-server mysql-server/root_password_again select l3tm31n | debconf-set-selections
RUN apt-get -y install mysql-server libmysql-java
RUN service mysql start && mysql --user=root --password=l3tm31n -e "CREATE DATABASE konakart; CREATE USER 'konakart'@'127.0.0.1' IDENTIFIED BY 'k0n4k4rt'; GRANT ALL ON konakart.* TO 'konakart'@'127.0.0.1'; CREATE USER 'konakart'@'localhost' IDENTIFIED BY 'k0n4k4rt'; GRANT ALL ON konakart.* TO 'konakart'@'localhost';"
ADD http://www.konakart.com/kkcounter/click.php?id=5 KonaKart-8.0.0.0-Linux-Install-64
RUN chmod +x KonaKart-8.0.0.0-Linux-Install-64
RUN ./KonaKart-8.0.0.0-Linux-Install-64 -S -DDatabaseType mysql -DDatabaseUrl jdbc:mysql://localhost:3306/konakart -DDatabaseUsername konakart -DDatabasePassword k0n4k4rt -DJavaJRE /usr/lib/jvm/java-8-openjdk-amd64/jre
RUN service mysql start && mysql -p konakart --user=konakart --password=k0n4k4rt < /usr/local/konakart/database/MySQL/konakart_demo.sql
CMD service mysql start && /usr/local/konakart/bin/startkonakart.sh && tail -F /usr/local/konakart/logs/catalina.out
EXPOSE 8780
