package it.formulaticket.services;

import it.formulaticket.entities.Ticket;
import it.formulaticket.repositories.TicketRepository;
import it.formulaticket.controllers.rest.support.exceptions.BarCodeAlreadyExistException;
import it.formulaticket.controllers.rest.support.exceptions.DateWrongRangeException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class TicketService {
    @Autowired
    private TicketRepository ticketRepository;

    @Transactional(readOnly = false)
    public void addTicket(Ticket ticket) throws BarCodeAlreadyExistException {
        if(ticket.getBarCode() != null && ticketRepository.existsByBarCode(ticket.getBarCode())){

            throw new BarCodeAlreadyExistException();
        }
        ticketRepository.save(ticket);
    }

    @Transactional(readOnly = true)
    public List<Ticket> showAllTicket(){
        return ticketRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Ticket> showAllTicket(int pageNumber,int pageSize, String sortBy){
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by(sortBy));
        Page<Ticket> pagedResult = ticketRepository.findAll(paging);
        if ( pagedResult.hasContent() ) {
            return pagedResult.getContent();
        }
        else {
            return new ArrayList<>();
        }
    }

    @Transactional(readOnly = true)
    public List<Ticket> showTicketByName(String name) {
        return ticketRepository.findByNameContaining(name);
    }



    @Transactional(readOnly = true)
    public List<Ticket> showTicketByBarCode(String barCode) {
        return ticketRepository.findByBarCode(barCode);
    }

    @Transactional(readOnly = true)
    public List<Ticket> showTicketByTrackName(String trackName) {
        return ticketRepository.findByTrackName(trackName);
    }

    @Transactional(readOnly = true)
    public List<Ticket> showTicketByGPName(String grandPrixName) {
        return ticketRepository.findByGrandPrixName(grandPrixName);
    }

    public List<Ticket> showTicketByDate(Date from, Date until,int gp,String type) throws DateWrongRangeException {
        if(from.compareTo(until) >0) {
            throw new DateWrongRangeException();
        }
        return ticketRepository.findByDate(from,until,gp,type);
    }
}
