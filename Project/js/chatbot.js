// Wait for the DOM to fully load before running the script
document.addEventListener("DOMContentLoaded", () => {
  // Get references to key elements in the chat UI
  const chatBody = document.getElementById("chat-body");      // Container for chat messages
  const chatInput = document.getElementById("chat-input");    // Text input for user messages
  const chatSend = document.getElementById("chat-send");      // Send button
  const chatPrompts = document.querySelectorAll(".chat-prompt"); // Predefined quick reply buttons

  // Function to append a new message bubble to the chat body
  function appendMessage(sender, text) {
    const msg = document.createElement("div");  // Create a div element for the message
    msg.className = sender;                      // Assign class 'user' or 'bot' for styling
    msg.innerText = text;                        // Set the message text content
    chatBody.appendChild(msg);                   // Add the message div to chat container
    chatBody.scrollTop = chatBody.scrollHeight; // Scroll chat to the bottom to show newest message
  }

  // Show initial welcome messages from the bot
  appendMessage("bot", "🏋️‍♂️ Welcome to Big Boss Gym! I'm GymBot.");
  appendMessage("bot", "🤖 You can ask about membership, pricing, classes, trainers, and more!");

  // Function to send user input to backend and display response
  function sendMessage(input) {
    if (!input) return;                // Ignore empty input
    appendMessage("user", input);     // Show user's message in chat
    chatInput.value = "";             // Clear input box after sending

    // Call backend chatbot API with encoded input message
    fetch(`http://localhost:5000/chatbot?msg=${encodeURIComponent(input)}`)
      .then(res => {
        // Check if response is okay, else throw error to be caught
        if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
        return res.text();            // Parse response as plain text
      })
      .then(reply => {
        // Slight delay before displaying bot reply for better UX
        setTimeout(() => appendMessage("bot", reply.trim()), 500);
      })
      .catch(err => {
        // Log error to console and show friendly error message in chat
        console.error(err);
        appendMessage("bot", "⚠️ Sorry, I couldn’t connect to the server.");
      });
  }

  // Add event listener to the send button to send message on click
  chatSend.addEventListener("click", () => sendMessage(chatInput.value.trim()));

  // Add event listener to input box to send message on Enter key press
  chatInput.addEventListener("keypress", e => {
    if (e.key === "Enter") sendMessage(chatInput.value.trim());
  });

  // Add click event listeners to each prompt button to send quick messages
  chatPrompts.forEach(button => {
    button.addEventListener("click", () => {
      sendMessage(button.innerText);
    });
  });
});
