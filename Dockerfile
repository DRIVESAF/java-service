# 构建阶段
FROM openjdk:17-slim AS build
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
COPY . .
RUN chmod +x mvnw && \
    --mount=type=cache,target=/root/.m2 \
    ./mvnw -f pom.xml clean package

# 打包阶段
FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /usr/app/target/*.jar ./app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app/app.jar"]