FROM centos:7

ADD tars/openresty-1.13.6.1.tar.gz /root/
ADD tars/orange-0.6.4.tar.gz /root/
ADD tars/lor.tar.gz /root/
ADD files/orange.sql /root/orange.sql
ADD files/build_table.sh /root/build_table.sh
ADD files/run.sh /root/run.sh

# 安装mariadb数据库和必须的工具
RUN yum install -y mariadb mariadb-server openssl-devel pcre-devel gcc gcc-c++ make java

# 编译安装openresty
WORKDIR /root/openresty-1.13.6.1
RUN ./configure -j2 --with-http_stub_status_module  \
    && make \
    && make install

# 执行build_table.sh 导入sql
RUN chmod u+x /root/build_table.sh \
    && chmod u+x /root/run.sh \
    && /root/build_table.sh

ENV PATH /usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:$PATH

# 编译安装lor
WORKDIR /root/lor
RUN make install

# 编译安装orange
WORKDIR /root/orange-0.6.4
RUN make install

COPY files/orange.conf /usr/local/orange/conf/

WORKDIR /usr/local/orange
CMD /root/run.sh
