package it.formulaticket.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
@Table(name="grandprix",schema="formula_ticket")
public class GrandPrix {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Basic
    @Column(name = "name", nullable = true, length = 45)
    private String name;

    @Basic
    @Column(name = "track", nullable = true, length = 45)
    private String track;

    @Basic
    @Column(name = "descr", nullable = true, length = 1000)
    private String descr;

    @Lob
    @Column(name="photo",nullable = true)
    @ToString.Exclude
    private byte[] photo;

    @Basic
    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_date")
    private Date startDate;

    @Basic
    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "end_date")
    private Date endDate;

    @OneToMany(mappedBy = "grandPrix", cascade = CascadeType.MERGE)
    @JsonIgnore
    @ToString.Exclude
    private List<Ticket> tickets;
}
