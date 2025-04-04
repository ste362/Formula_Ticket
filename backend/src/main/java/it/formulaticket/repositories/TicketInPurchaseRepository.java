package it.formulaticket.repositories;

import it.formulaticket.entities.TicketInPurchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TicketInPurchaseRepository extends JpaRepository<TicketInPurchase,Integer> {
}
