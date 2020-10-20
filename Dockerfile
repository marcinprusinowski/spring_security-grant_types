FROM openjdk:15-slim
COPY ./target/granttypes-1.0.jar ./
EXPOSE 8080
ENTRYPOINT ["java" , "-jar" , "granttypes-1.0.jar"]