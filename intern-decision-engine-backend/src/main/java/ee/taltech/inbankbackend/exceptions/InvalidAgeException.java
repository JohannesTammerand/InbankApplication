package ee.taltech.inbankbackend.exceptions;

public class InvalidAgeException extends Throwable{
    private final String message;
    private final Throwable cause;

    public InvalidAgeException(String message){
        this(message, null);
    }

    public InvalidAgeException(String message, Throwable cause){
        this.message = message;
        this.cause = cause;
    }

    @Override
    public Throwable getCause() {
        return cause;
    }

    @Override
    public String getMessage() {
        return message;
    }
}
