package it.formulaticket.controllers.rest.support.authentication;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;


import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;


public class JwtAuthenticationConverter implements Converter<Jwt, AbstractAuthenticationToken> {
    @Value("${keycloak.resource}")
    private String CLIENT_NAME;


    @Override
    @SuppressWarnings("unchecked")
    public AbstractAuthenticationToken convert(final Jwt source) {
        Map<String, Object> resourceAccess = source.getClaim("realm_access");
        Collection<String> resourceRoles = (Collection<String>) resourceAccess.get("roles");
        Set<GrantedAuthority> authorities = resourceRoles.stream().map(SimpleGrantedAuthority::new).collect(Collectors.toSet());
        return new JwtAuthenticationToken(source, authorities);
    }


}

