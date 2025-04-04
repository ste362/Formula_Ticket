package it.formulaticket.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.util.Date;
import java.util.List;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
@Table(name = "ticket", schema = "formula_ticket")
public class Ticket {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Basic
    @Column(name = "name", nullable = true, length = 45)
    private String name;

    @Basic
    @Column(name = "type", nullable = true, length = 45)
    private String type;

    @Basic
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "valid_from")
    private Date validFrom;

    @Basic
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "valid_until")
    private Date validUntil;

    @Basic
    @Column(name = "price", nullable = true)
    private float price;

    @Basic
    @Column(name = "qta", nullable = true)
    private int qta;

    @Basic
    @Column(name = "barcode", nullable = true, length = 70)
    private String barCode;

    @Basic
    @Column(name = "session", nullable = true, length = 45)
    private String session;

    @Basic
    @Column(name = "descr", nullable = true, length = 500)
    private String descr;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name="grandprix")
    @ToString.Exclude
    private GrandPrix grandPrix;

    @OneToMany(targetEntity = TicketInPurchase.class, mappedBy = "ticket", cascade = CascadeType.MERGE)
    @JsonIgnore
    @ToString.Exclude
    private List<TicketInPurchase> ticketsInPurchase;


}