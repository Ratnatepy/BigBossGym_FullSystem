package bigboss_rmi;

public class ChatBridge {
    public static void main(String[] args) {
        try {
            String input = args[0].toLowerCase();

            // Internal debug log (terminal only)
            System.err.println("[ChatBridge] Received input: " + input);

            String reply;

            if (input.contains("membership")) {
                reply = "🏷️ We offer three membership plans:\n\n"
                      + "Standard Membership – $30/month\n"
                      + "- Access to gym facilities\n"
                      + "- Locker room usage\n"
                      + "- Standard workout equipment\n"
                      + "- No time limitation\n\n"
                      + "Premium Membership – $50/month\n"
                      + "- All Standard benefits\n"
                      + "- Group fitness class access\n"
                      + "- Sauna and steam room\n"
                      + "- Personal training discounts\n\n"
                      + "Family Membership – $80/month\n"
                      + "- All Premium benefits\n"
                      + "- Up to 4 members\n"
                      + "- Family workout sessions\n"
                      + "- Priority class booking";

            } else if (input.contains("payment")) {
                reply = "💳 You can pay using any of the following methods:\n"
                      + "- Credit Card\n"
                      + "- ABA Pay\n"
                      + "- Wing\n"
                      + "- Cash";

            } else if (input.contains("schedule")) {
                reply = "📅 Here is the weekly workout schedule:\n\n"
                      + "Monday: Yoga – 8:00 AM, Strength Training – 6:00 PM\n"
                      + "Tuesday: Cardio – 9:00 AM, HIIT – 7:00 PM\n"
                      + "Wednesday: Zumba – 8:00 AM, CrossFit – 6:00 PM\n"
                      + "Thursday: HIIT – 9:00 AM, Yoga – 7:00 PM\n"
                      + "Friday: Cardio – 8:00 AM, Strength Training – 6:00 PM\n"
                      + "Saturday: Yoga – 9:00 AM, Zumba – 5:00 PM\n"
                      + "Sunday: Rest & Recovery";

            } else if (input.contains("trainer")) {
                reply = "🧑‍🏫 Our certified trainers:\n\n"
                      + "Bun Ratnatepy – 2 years\n"
                      + "- Specialty: Yoga\n- Mon–Fri, 6AM–12PM\n- Email: bunratnatepy@gmail.com\n\n"
                      + "Chhin Visal – 8 years\n"
                      + "- Specialty: Cardio & Weight Loss\n- Tue–Thu, 10AM–6PM\n- Email: chhinvisal@gmail.com\n\n"
                      + "HAYSAVIN RONGRAVIDWIN – 5 years\n"
                      + "- Specialty: Strength Training\n- Mon–Sun, 1AM–5PM\n- Email: winwin@gmail.com\n\n"
                      + "HOUN Sithai – 1 year\n"
                      + "- Specialty: Pilates\n- Wed–Fri, 7AM–2PM\n- Email: sithai@example.com";

            } else if (input.contains("personal training")) {
                reply = "💪 Yes, we offer personal training services!\n"
                      + "Please contact us via the 'Send Us a Message' form on our website to get started.";

            } else {
                reply = "🤖 Sorry, I didn't understand that. Try asking about membership, payments, schedule, or trainers.";
            }

            // Clean output to chatbot UI
            System.out.println(reply);

        } catch (Exception e) {
            System.err.println("ChatBridge exception: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
