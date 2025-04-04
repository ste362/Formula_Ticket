package it.formulaticket.controllers.rest.support.authentication;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import it.formulaticket.controllers.rest.support.exceptions.KeycloakErrorException;
import it.formulaticket.controllers.rest.support.exceptions.MailUserAlreadyExistsException;
import it.formulaticket.entities.User;
import lombok.experimental.UtilityClass;
import lombok.extern.log4j.Log4j2;
import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.keycloak.admin.client.CreatedResponseUtil;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import javax.ws.rs.core.Response;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


@UtilityClass
@Log4j2
public class Utils {


    public Jwt getPrincipal() {
        return (Jwt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }

    public String getAuthServerId() {
        return getTokenNode().get("subject").asText();
    }

    public String getName() {
        return getTokenNode().get("sub").asText();
    }

    public String getEmail() {
        return getTokenNode().get("claims").get("preferred_username").asText();
    }

    private JsonNode getTokenNode() {
        Jwt jwt = getPrincipal();
        System.out.println(jwt);
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        String jwtAsString;
        JsonNode jsonNode;
        try {
            jwtAsString = objectMapper.writeValueAsString(jwt);
            jsonNode = objectMapper.readTree(jwtAsString);
        } catch (JsonProcessingException e) {
            log.error(e.getMessage());
            throw new RuntimeException("Unable to retrieve user's info!");
        }
        return jsonNode;
    }

    public  Date stringToDate(String date) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(date);
        } catch (ParseException e) {
            throw new RuntimeException();
        }
    }

    public static String addToKeycloak(User userToAdd, String password) throws MailUserAlreadyExistsException, KeycloakErrorException {

        String usernameAdmin = "adminF1";
        String passwordAdmin = "admin";
        String clientName = "springboot-keycloak";
        String role = "";
        String email = userToAdd.getEmail();
        String lastName = userToAdd.getLastName();
        String serverUrl = "http://localhost:8080/auth";
        String realm = "FormulaTicket";
        String clientId = clientName;
        String clientSecret = "";

        Keycloak keycloak = KeycloakBuilder.builder()
                .serverUrl(serverUrl)
                .realm(realm)
                .grantType(OAuth2Constants.PASSWORD)
                .clientId(clientId)
               // .clientSecret(clientSecret)
                .username(usernameAdmin)
                .password(passwordAdmin)
                .build();


            // Define user
            UserRepresentation user = new UserRepresentation();
            user.setEnabled(true);
            user.setUsername(email);
            user.setEmail(email);

            //user.setAttributes(Collections.singletonMap("origin", Arrays.asList("demo")));

            // Get realm
            RealmResource realmResource = keycloak.realm(realm);
            UsersResource usersResource = realmResource.users();

            // Create user (requires manage-users role)
            Response response = usersResource.create(user);
            //System.out.printf("Repsonse: %s %s%n", response.getStatus(), response.getStatusInfo());
            if(response.getStatus()==409){
                throw new MailUserAlreadyExistsException();
            }
            else if(response.getStatus()!=201){
                throw new KeycloakErrorException();
            }
            System.out.println(response.getLocation());
            String userId = CreatedResponseUtil.getCreatedId(response);
            System.out.printf("User created with userId: %s%n", userId);

            // Define password credential
            CredentialRepresentation passwordCred = new CredentialRepresentation();
            passwordCred.setTemporary(false);
            passwordCred.setType(CredentialRepresentation.PASSWORD);
            passwordCred.setValue(password);

            UserResource userResource = usersResource.get(userId);

            // Set password credential
            userResource.resetPassword(passwordCred);

            // Get client
            //ClientRepresentation app1Client = realmResource.clients().findByClientId(clientName).get(0);

            // Get client level role (requires view-clients role)
            //RoleRepresentation userClientRole = realmResource.clients().get(app1Client.getId()).roles().get(role).toRepresentation();

            // Assign client level role to user
           // userResource.roles().clientLevel(app1Client.getId()).add(Arrays.asList(userClientRole));

            // Send password reset E-Mail
            // VERIFY_EMAIL, UPDATE_PROFILE, CONFIGURE_TOTP, UPDATE_PASSWORD, TERMS_AND_CONDITIONS
            //usersResource.get(userId).executeActionsEmail(Arrays.asList("UPDATE_PASSWORD"));

            // Delete User
            //userResource.remove();

        return userId;
    }
}
