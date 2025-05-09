package it.formulaticket.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
@Table(name = "user", schema = "formula_ticket")
public class             User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Basic
    @Column(name = "code", nullable = true, length = 70)
    private String code;

    @Transient
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    @Basic
    @Column(name = "first_name", nullable = true, length = 45)
    private String firstName;

    @Basic
    @Column(name = "last_name", nullable = true, length = 45)
    private String lastName;

    @Basic
    @Column(name = "telephone_number", nullable = true, length = 20)
    private String telephoneNumber;

    @Basic
    @Column(name = "email", nullable = true, length = 90)
    private String email;

    @Basic
    @Column(name = "address", nullable = true, length = 150)
    private String address;

    @OneToMany(mappedBy = "buyer", cascade = CascadeType.MERGE)
    @JsonIgnore
    @ToString.Exclude
    private List<Purchase> purchases;
}
