component hint="Input guardrail: runs on every user message before it reaches the model" {
    public struct function validate(required string message) {
        if (findNoCase("ignore previous instructions", arguments.message)) {
            return { result: "failure", message: "Prompt injection attempt blocked." };
        }
        return { result: "success" };
    }
}
