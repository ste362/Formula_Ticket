package it.formulaticket.controllers.rest;



import it.formulaticket.controllers.rest.support.ResponseMessage;
import it.formulaticket.controllers.rest.support.exceptions.PriceMismatchException;
import it.formulaticket.entities.Purchase;
import it.formulaticket.entities.User;
import it.formulaticket.controllers.rest.support.exceptions.DateWrongRangeException;
import it.formulaticket.controllers.rest.support.exceptions.QuantityProductUnavailableException;
import it.formulaticket.controllers.rest.support.exceptions.UserNotFoundException;
import it.formulaticket.services.PurchasingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import javax.validation.Valid;
import java.util.Date;
import java.util.List;


@RestController
@RequestMapping("/purchases")
public class PurchasingController {
    @Autowired
    private PurchasingService purchasingService;

    //@PreAuthorize("hasAnyAuthority('user')")
    @PostMapping("/create")
    @ResponseStatus(code = HttpStatus.OK)
    public ResponseEntity create(@RequestBody @Valid Purchase purchase) {
        //System.out.println("crea acquisto");
        //System.out.println(purchase);
        try {
            Purchase add=purchasingService.addPurchase(purchase);
            //System.out.println("aggiunto");
            //System.out.println(add);
            return new ResponseEntity<>(add, HttpStatus.OK);
        } catch (QuantityProductUnavailableException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Product quantity unavailable!", e); // realmente il messaggio dovrebbe essere più esplicativo (es. specificare il prodotto di cui non vi è disponibilità)
        } catch (PriceMismatchException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Price is changed!", e);
        }
    }
    //@PreAuthorize("hasAnyAuthority('admin')")
    @PostMapping("/getPurchases{user}")
    public List<Purchase> getPurchases(@RequestBody @Valid User user) throws UserNotFoundException {
        System.out.println(user);
        System.out.println(purchasingService.getPurchasesByUser(user));
        try {
            return purchasingService.getPurchasesByUser(user);
        } catch (UserNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User not found!", e);
        }
    }

    @GetMapping("/{user}/{startDate}/{endDate}")
    public ResponseEntity getPurchasesInPeriod(@Valid @PathVariable("user") User user, @PathVariable("startDate") @DateTimeFormat(pattern = "yyyy-MM-dd") Date start, @PathVariable("endDate") @DateTimeFormat(pattern = "yyyy-MM-dd") Date end) {
        try {
            List<Purchase> result = purchasingService.getPurchasesByUserInPeriod(user, start, end);
            if ( result.size() <= 0 ) {
                return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
            }
            return new ResponseEntity<>(result, HttpStatus.OK);
        } catch (UserNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User not found XXX!", e);
        } catch (DateWrongRangeException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Start date must be previous end date XXX!", e);
        }
    }


}
