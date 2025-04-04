package it.formulaticket.services;



import it.formulaticket.controllers.rest.support.exceptions.PriceMismatchException;
import it.formulaticket.entities.Purchase;
import it.formulaticket.entities.Ticket;
import it.formulaticket.entities.TicketInPurchase;
import it.formulaticket.entities.User;
import it.formulaticket.repositories.PurchaseRepository;
import it.formulaticket.repositories.TicketInPurchaseRepository;
import it.formulaticket.repositories.TicketRepository;
import it.formulaticket.repositories.UserRepository;
import it.formulaticket.controllers.rest.support.exceptions.DateWrongRangeException;
import it.formulaticket.controllers.rest.support.exceptions.QuantityProductUnavailableException;
import it.formulaticket.controllers.rest.support.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.FlushModeType;
import java.util.Date;
import java.util.List;


@Service
public class PurchasingService {
    @Autowired
    private PurchaseRepository purchaseRepository;
    @Autowired
    private TicketInPurchaseRepository ticketInPurchaseRepository;

    @Autowired
    private TicketRepository ticketRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private EntityManager entityManager;


    @Transactional(readOnly = false)
    public Purchase addPurchase(Purchase purchase) throws QuantityProductUnavailableException, PriceMismatchException {
        float currentPrice=0f;
        for(TicketInPurchase tit : purchase.getTicketsInPurchase()){
            int currentQuantity=ticketRepository.findTicketByID(tit.getTicket().getId()).getQta();
            //System.out.println("qta corrente: "+currentQuantity + "pre = "+tit.getQuantity());
            if(currentQuantity-tit.getQuantity()<0){
                throw new QuantityProductUnavailableException();
            }
            currentPrice+=ticketRepository.findTicketByID(tit.getTicket().getId()).getPrice()*tit.getQuantity();
        }
        //System.out.println("current "+currentPrice+" pre "+purchase.getPrice());
        if(currentPrice!=purchase.getPrice()){
            throw new PriceMismatchException();
        }
        Purchase result = purchaseRepository.save(purchase);
        for ( TicketInPurchase pip : result.getTicketsInPurchase() ) {
            pip.setPurchase(result);
            TicketInPurchase justAdded = ticketInPurchaseRepository.save(pip);
            entityManager.refresh(justAdded);
            Ticket ticket = justAdded.getTicket();
            int newQuantity = ticket.getQta() - pip.getQuantity();
            if ( newQuantity < 0 ) {
                throw new QuantityProductUnavailableException();
            }
            ticket.setQta(newQuantity);
            entityManager.refresh(pip);
        }
        entityManager.refresh(result);
        return result;
    }

    @Transactional(readOnly = true)
    public List<Purchase> getPurchasesByUser(User user) throws UserNotFoundException {
        if ( !userRepository.existsById(user.getId()) ) {
            throw new UserNotFoundException();
        }
        return purchaseRepository.findByBuyer(user);
    }

    @Transactional(readOnly = true)
    public List<Purchase> getPurchasesByUserInPeriod(User user, Date startDate, Date endDate) throws UserNotFoundException, DateWrongRangeException {
        if ( !userRepository.existsById(user.getId()) ) {
            throw new UserNotFoundException();
        }
        if ( startDate.compareTo(endDate) >= 0 ) {
            throw new DateWrongRangeException();
        }
        return purchaseRepository.findByBuyerInPeriod(startDate, endDate, user);
    }

    @Transactional(readOnly = true)
    public List<Purchase> getAllPurchases() {
        return purchaseRepository.findAll();
    }


}
