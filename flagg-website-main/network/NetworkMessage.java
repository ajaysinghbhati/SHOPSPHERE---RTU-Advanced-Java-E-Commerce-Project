package com.shopsphere.network.model;

import java.io.Serializable;

/**
 * RTU Syllabus Serialization Demo:
 * Network command and response transfer objects sent across Sockets via ObjectOutputStream/ObjectInputStream.
 */
public class NetworkMessage implements Serializable {
    private static final long serialVersionUID = 1L;

    private String command; // "GET_PRODUCT", "GET_STOCK", "SEARCH_PRODUCT", "UPDATE_STOCK"
    private Object payload;
    private boolean success;
    private String message;

    public NetworkMessage() {}

    public NetworkMessage(String command, Object payload) {
        this.command = command;
        this.payload = payload;
    }

    public String getCommand() { return command; }
    public void setCommand(String command) { this.command = command; }

    public Object getPayload() { return payload; }
    public void setPayload(Object payload) { this.payload = payload; }

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}
