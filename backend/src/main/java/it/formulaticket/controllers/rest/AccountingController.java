package it.formulaticket.controllers.rest;


import it.formulaticket.controllers.rest.support.ResponseMessage;
import it.formulaticket.controllers.rest.support.authentication.Utils;
import it.formulaticket.controllers.rest.support.exceptions.KeycloakErrorException;
import it.formulaticket.controllers.rest.support.exceptions.MailUserAlreadyExistsException;
import it.formulaticket.controllers.rest.support.exceptions.MailUserNotExistsException;
import it.formulaticket.entities.User;
import it.formulaticket.services.AccountingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;


@RestController
@RequestMapping("/users")
public class AccountingController {
    @Autowired
    private AccountingService accountingService;


    @PostMapping("/create")
    public ResponseEntity create(@RequestBody @Valid User user) {
        try {
            //System.out.println(user);
            user.setCode(Utils.addToKeycloak(user,user.getPassword()));
            user.setPassword(null);
            User added = accountingService.registerUser(user);
            return new ResponseEntity(added, HttpStatus.OK);
        } catch (MailUserAlreadyExistsException e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR_MAIL_USER_ALREADY_EXISTS"), HttpStatus.BAD_REQUEST);
        } catch (KeycloakErrorException e) {
            return new ResponseEntity<>(new ResponseMessage("KEYCLOAK ERROR"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping
    public List<User> getAll() {
        return accountingService.getAllUsers();
    }

    @GetMapping("/getUser")
    public ResponseEntity getByEmail() {
        System.out.println("Email token "+Utils.getEmail());
        try {
            List<User> users = accountingService.getByEmail(Utils.getEmail());
            //System.out.println("Users "+users);
            if (users.size() > 1) {
                return new ResponseEntity<>(new ResponseMessage("INTERNAL_ERROR: MORE THAN ON USER FIND WITH THE SAME EMAIL"), HttpStatus.INTERNAL_SERVER_ERROR);
            }
            return new ResponseEntity(users.get(0), HttpStatus.OK);
        } catch (MailUserNotExistsException e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR_MAIL_USER_NOT_EXISTS"), HttpStatus.BAD_REQUEST);
        }
    }
}
