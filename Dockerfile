FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app_java

COPY helloworld.java .

CMD ["java", "helloworld.java"]
