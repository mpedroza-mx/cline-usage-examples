#!/bin/bash
# >>> cline wrapper init>>>
cline() {
    betterleaks_result=$(betterleaks dir . --report-format json --report-path - --no-banner --log-level error)
    total_secrets_found=$(echo "$betterleaks_result" | jq '[.[] | .RuleID] | length')
    if [ "$total_secrets_found" -gt 0 ]; then


        echo "\033[1;31m🚨 [DANGER]: CRITICAL::: We have detect exposed secrets or credentials in the current repository.
                Cline execution will be automatically cancelled due security policies.
                Please remove the credentials from the code before interacting with the AI.\033[0m"


        echo  "BETTERLEAKS REPORT"

        echo "$betterleaks_result" | jq -r '
            def rpad(len; fill): tostring | (len - length) as $l | . + ((fill * $l)[0:$l]);
            "| \("FILE" | rpad(100; " ")) | \("LINE" | rpad(5; " ")) | \("RULE" | rpad(18; " ")) | \("CONFIDENCE" | rpad(10; " ")) |",
            "| \("-" | rpad(100; "-")) | \("-" | rpad(5; "-")) | \("-" | rpad(18; "-")) | \("-" | rpad(10; "-")) |",
            (.[] | "| \(.File | rpad(100; " ")) | \(.StartLine | rpad(5; " ")) | \(.RuleID | rpad(18; " ")) | \(.Attributes.confidence | rpad(10; " ")) |")
        '
        return 1
    fi
    command cline "$@"
}
# <<< cline wrapper init <<<