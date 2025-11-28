FROM bellsoft/liberica-runtime-container:jdk-25-slim-musl as builder

WORKDIR /app

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

RUN chmod +x ./gradlew

RUN ./gradlew dependencies --no-daemon

COPY src src

RUN ./gradlew build --no-daemon

FROM bellsoft/liberica-runtime-container:jre-25-slim-glibc

ENV PORT=3000

COPY --from=builder /app/build/libs/deployment-0.0.1.jar /

EXPOSE ${PORT}

CMD ["java", "-Dserver.port=${PORT}", "--enable-native-access=ALL-UNNAMED", "-jar", "/deployment-0.0.1.jar"]