From centos:7

#Install epel-release repo
RUN yum -y install --setopt=tsflags=nodocs epel-release && \
 yum -y install --setopt=tsflags=nodocs nginx && \
 yum clean all

RUN yum -y install nginx

ADD nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
#EXPOSE 443

ADD /docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

