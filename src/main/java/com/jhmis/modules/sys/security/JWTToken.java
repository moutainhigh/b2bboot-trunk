package com.jhmis.modules.sys.security;

import org.apache.shiro.authc.AuthenticationToken;

public class JWTToken implements AuthenticationToken {
    // 密钥
    private String token;

    public JWTToken(String token) {
        this.token = token;
    }

    public String getToken() {
        return token;
    }

    @Override
    public Object getPrincipal() {
        return token;
    }

    @Override
    public Object getCredentials() {
        return token;
    }
}
