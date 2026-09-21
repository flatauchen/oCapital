# -----------------------------------------------------------------------------
# Etapa 1: Build da Aplicação Java com Maven
# -----------------------------------------------------------------------------
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app

# Copia as configurações do Maven e o pom.xml para resolver dependências
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia o código-fonte e gera o .jar executável
COPY src ./src
RUN mvn clean package -DskipTests

# -----------------------------------------------------------------------------
# Etapa 2: Imagem Final Leve para Execução (Runtime)
# -----------------------------------------------------------------------------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Cria usuário não-root para execução segura no Render
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copia o JAR gerado na etapa de build
COPY --from=builder /app/target/*.jar app.jar

# Expoe a porta padrão do Render
EXPOSE 8080

# Parâmetros otimizados para rodar com pouca memória (512MB RAM do plano Free)
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Dserver.port=8080"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]