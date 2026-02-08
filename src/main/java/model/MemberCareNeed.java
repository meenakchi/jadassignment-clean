
package model;

import java.sql.Timestamp;

public class MemberCareNeed {
    private int careNeedId;
    private int memberId;
    private String needCategory; // MOBILITY, MEDICATION, NUTRITION, etc.
    private String description;
    private String priority; // HIGH, MEDIUM, LOW
    private String status; // ACTIVE, RESOLVED
    private Timestamp createdAt;
    
    // Constructors, getters, setters
}