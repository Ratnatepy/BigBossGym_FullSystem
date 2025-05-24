package bigboss_rmi;

import java.rmi.server.UnicastRemoteObject;
import java.rmi.RemoteException;

public class GymServiceImpl extends UnicastRemoteObject implements GymService {
    protected GymServiceImpl() throws RemoteException {
        super();
    }

    @Override
    public String askQuestion(String input) {
        input = input.toLowerCase();

        if (input.contains("membership")) {
            return "We offer Standard, Premium, and Family memberships.";
        } else if (input.contains("join")) {
            return "It costs $30 to join with monthly plans starting at $10.";
        } else if (input.contains("trainer")) {
            return "Our trainers include Bun Ratnatepy (Yoga), Chhin Visal (Cardio), and more.";
        } else if (input.contains("schedule")) {
            return "You can view class schedules on our website or in the app.";
        } else {
            return "Sorry, I didn't understand that. Try asking about membership, payments, or trainers.";
        }
    }
}
