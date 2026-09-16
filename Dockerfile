# ----------------------------------------------------
# ÉTAPE 1 : Build de l'application avec Maven & Java 21
# ----------------------------------------------------
FROM maven:3.9.6-eclipse-temurin-21 AS builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier de configuration Maven et le code source
COPY pom.xml .
COPY src ./src

# Compiler le projet et générer le JAR (en ignorant les tests pour accélérer le build)
RUN mvn clean package -DskipTests

# ----------------------------------------------------
# ÉTAPE 2 : Image d'exécution finale (Légère & Sécurisée)
# ----------------------------------------------------
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copier uniquement le fichier JAR généré à l'étape 1
COPY --from=builder /app/target/*.jar app.jar

# Informer Docker que le conteneur écoute sur le port 8080
EXPOSE 8080

# Commande pour démarrer l'application Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]