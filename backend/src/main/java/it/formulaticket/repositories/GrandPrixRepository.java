package it.formulaticket.repositories;

import it.formulaticket.entities.GrandPrix;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface GrandPrixRepository extends JpaRepository<GrandPrix,Integer> {
    Page<GrandPrix> findByStartDateIsGreaterThan(Pageable paging, Date startDate);
    List<GrandPrix> findByNameContainingAndStartDateIsGreaterThan(String name, Date startDate);
    List<GrandPrix> findByTrack(String track);
}
