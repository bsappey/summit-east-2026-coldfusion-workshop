component hint="Output guardrail: runs on every model reply before it is returned" {
    public struct function validate(required string message) {
        if (reFindNoCase("\b\d{3}-\d{2}-\d{4}\b", arguments.message)) {
            return { result: "failure", message: "Response contained an SSN-like value." };
        }
        return { result: "success" };
    }
}
