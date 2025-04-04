package it.formulaticket.services;

import it.formulaticket.controllers.rest.support.exceptions.BarCodeAlreadyExistException;
import it.formulaticket.controllers.rest.support.exceptions.DateWrongRangeException;
import it.formulaticket.entities.GrandPrix;
import it.formulaticket.entities.Ticket;

import it.formulaticket.repositories.GrandPrixRepository;
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
public class GrandPrixService {
    @Autowired
    private GrandPrixRepository grandPrixRepository;

    @Transactional(readOnly = false)
    public void addGrandPrix(GrandPrix grandPrix) throws BarCodeAlreadyExistException {
        grandPrixRepository.save(grandPrix);
    }

    @Transactional(readOnly = true)
    public List<GrandPrix> showAllGrandPrix(){
        return grandPrixRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<GrandPrix> showAllGrandPrix(int pageNumber,int pageSize, String sortBy,Date startDate){
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by(sortBy));
        Page<GrandPrix> pagedResult = grandPrixRepository.findByStartDateIsGreaterThan(paging,startDate);
        if ( pagedResult.hasContent() ) {
            return pagedResult.getContent();
        }
        else {
            return new ArrayList<>();
        }
    }

    @Transactional(readOnly = true)
    public List<GrandPrix> showGrandPrixByName(String grandPrixName,Date startDate){

        return grandPrixRepository.findByNameContainingAndStartDateIsGreaterThan(grandPrixName,startDate);

    }

}
