package it.formulaticket.repositories;


import it.formulaticket.entities.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Integer> {

    List<Ticket> findByNameContaining(String name);
    List<Ticket> findByBarCode(String name);
    boolean existsByBarCode(String barCode);

    @Query( "select t from Ticket as t , GrandPrix as gp where t.grandPrix.id = gp.id and gp.track = ?1")
    List<Ticket> findByTrackName(String trackName);

    @Query( "select t from Ticket as t , GrandPrix as gp where t.grandPrix.id = gp.id and gp.name = ?1")
    List<Ticket> findByGrandPrixName(String granPrixName);

    @Query( "select t from Ticket as t where t.validFrom = DATE(?1) and t.validUntil = DATE(?2) and t.grandPrix.id = ?3 and t.type=?4 and t.qta>0")
    List<Ticket> findByDate(Date from, Date until, int gp,String type);

    @Query( "select t from Ticket as t where t.id=?1")
    Ticket findTicketByID(int id);
}
