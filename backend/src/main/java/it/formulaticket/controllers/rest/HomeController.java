package it.formulaticket.controllers.rest;



import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/home")
public class HomeController {


    @GetMapping("/hello")
    public String hello(@RequestParam(value = "someValue") int value) {
        return "Welcome,  " + value + " !";
    }


}


