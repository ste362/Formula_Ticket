package it.formulaticket.controllers.rest;



import it.formulaticket.controllers.rest.support.ResponseMessage;
import it.formulaticket.controllers.rest.support.authentication.Utils;
import it.formulaticket.entities.Ticket;
import it.formulaticket.controllers.rest.support.exceptions.BarCodeAlreadyExistException;
import it.formulaticket.controllers.rest.support.exceptions.DateWrongRangeException;
import it.formulaticket.services.TicketService;
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
@RequestMapping("/tickets")
public class TicketsController {
    @Autowired
    private TicketService ticketService;

    @GetMapping("/uno")
    public String getUno() {

        return ticketService.showAllTicket().toString();
    }

    @PreAuthorize("hasAnyAuthority('admin')")
    @PostMapping
    public ResponseEntity create(@RequestBody @Valid Ticket ticket) {
        try {
            ticketService.addTicket(ticket);
        } catch (BarCodeAlreadyExistException e) {
            return new ResponseEntity<>(new ResponseMessage("Barcode already exist!"), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(new ResponseMessage("Added successful!"), HttpStatus.OK);
    }

    @GetMapping
    public List<Ticket> getAll() {
        return ticketService.showAllTicket();
    }

    //@PreAuthorize("hasAnyAuthority('admin')")
    @GetMapping("/paged")
    public ResponseEntity getAll(@RequestParam(value = "pageNumber", defaultValue = "0") int pageNumber, @RequestParam(value = "pageSize", defaultValue = "10") int pageSize, @RequestParam(value = "sortBy", defaultValue = "id") String sortBy) {
        List<Ticket> result = ticketService.showAllTicket(pageNumber, pageSize, sortBy);
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PreAuthorize("hasAnyAuthority('admin')")
    @GetMapping("/search/by_name")
    public ResponseEntity getByName(@RequestParam(required = false) String name) {
        List<Ticket> result = ticketService.showTicketByName(name);
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/search/by_track_name")
    public ResponseEntity getByTrackName(@RequestParam(required = false) String trackName) {
        List<Ticket> result = ticketService.showTicketByTrackName(trackName);
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/search/by_grandPrix_name")
    public ResponseEntity getByGrandPrixName(@RequestParam(required = false) String grandPrixName) {
        List<Ticket> result = ticketService.showTicketByGPName(grandPrixName);
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/search/by_all{startDate}{endDate}{grandPrixID}{type}")
    public ResponseEntity getByAll(@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate,@RequestParam(required = false) int grandPrixID,@RequestParam(required = false) String type) {
        //System.out.println("start "+Utils.stringToDate(startDate)+" end: "+Utils.stringToDate(endDate) +" type:"+type);
        try {
            List<Ticket> result = ticketService.showTicketByDate(Utils.stringToDate(startDate), Utils.stringToDate(endDate),grandPrixID,type);
           // System.out.println(result);
            if ( result.size() <= 0 ) {
                return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
            }
            return new ResponseEntity<>(result, HttpStatus.OK);
        } catch (DateWrongRangeException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Start date must be previous end date XXX!", e);
        }
    }

}
