package bigboss_rmi;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class GymServiceImpl extends UnicastRemoteObject implements GymService {

    public GymServiceImpl() throws RemoteException {
        super();
        System.out.println("🟢 GymServiceImpl: RMI service started and waiting for client requests...");
    }

    @Override
    public String askQuestion(String message) throws RemoteException {
        System.out.println("📥 [Client -> Server] Received from client: \"" + message + "\"");

        String response;
        String msg = message.trim().toLowerCase();

        if (msg.contains("membership") && msg.contains("type")) {
            response = "We offer 3 types: Basic, Premium, and Family Membership.";
        } else if (msg.contains("cost") || msg.contains("price")) {
            response = "The cost starts at $25/month for Standard , $50/month for Premium, and $70/month for Family.";
        } else if (msg.contains("schedule") || msg.contains("class")) {
            response = "Classes run daily from 6AM to 9PM. Check the full schedule on the home page.";
        } else if (msg.contains("trainer")) {
            response = "Our certified trainers specialize in strength, cardio, and flexibility training.";
        } else if (msg.contains("payment")) {
            response = "You can pay via Visa, MasterCard, ABA, or Wing. Just go to the Payments page.";
        } else if (msg.contains("contact") || msg.contains("support")) {
            response = "You can contact us via email: bigbozz168@gmail.com or Telegram: +855 11 434 668.";
        } else if (msg.contains("hours") || msg.contains("open")) {
            response = "We're open daily from 5AM to 10PM, including weekends!";
        } else if (msg.contains("location") || msg.contains("where")) {
            response = "Big Boss Gym is located at Street 271, Phnom Penh. Check the Contact page for directions.";
        } else {
            response = "🤔 Sorry, I didn't understand that. Try asking about membership, payments, or trainers!";
        }

        System.out.println("📤 [Server -> Client] Replying with: \"" + response + "\"");
        return response;
    }
}
