include:
  - web.jdk

tomcat-install:
  file.managed:
    - name: /usr/local/src/apache-tomcat-8.0.46.tar.gz
    - source: salt://web/files/apache-tomcat-8.0.46.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src/ && tar xf apache-tomcat-8.0.46.tar.gz && mv apache-tomcat-8.0.46 /usr/local/ && ln -s /usr/local/apache-tomcat-8.0.46 /usr/local/tomcat
    - unless: test -L /usr/local/tomcat && test -d /usr/local/apache-tomcat-8.0.46
