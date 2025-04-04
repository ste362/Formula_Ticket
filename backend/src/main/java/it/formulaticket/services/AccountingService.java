package it.formulaticket.services;

import it.formulaticket.controllers.rest.support.exceptions.MailUserNotExistsException;
import it.formulaticket.entities.User;
import it.formulaticket.repositories.UserRepository;
import it.formulaticket.controllers.rest.support.exceptions.MailUserAlreadyExistsException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
public class AccountingService {
    @Autowired
    private UserRepository userRepository;


    @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
    public User registerUser(User user) throws MailUserAlreadyExistsException {
        if ( userRepository.existsByEmail(user.getEmail()) ) {
            throw new MailUserAlreadyExistsException();
        }

        return userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }


    @Transactional(readOnly = true)
    public List<User> getByEmail(String email) throws MailUserNotExistsException {
        if (!userRepository.existsByEmail(email) ) {
            throw new MailUserNotExistsException();
        }
        return userRepository.findByEmail(email);
    }
}
