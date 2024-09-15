public class TriggerHandlerAccount extends TriggerHandler {

    // Before inserting a new Account, we add the suffix ' - Adaptus' to the Account name.
    // If the total length exceeds 80 characters, the Account name is truncated.
    public override void beforeInsert() {
        for(Account acc : (List<Account>) Trigger.new) {          
            String suffix = ' - Adaptus';
            if(acc.Name.length() + suffix.length() > 80) {
                acc.Name = acc.Name.substring(0, 80 - suffix.length());
            }
            acc.Name += suffix;
        }
    }

    // After an Account is inserted, we create a new Contact associated with the Account.
    public override void afterInsert() {
        List<Contact> contacts = new List<Contact>();
        for(Account acc : (List<Account>) Trigger.new) {
            contacts.add(createNewContact(acc)); 
        }
        Database.insert(contacts);
    }

    // After an Account is updated, we also create a new Contact as a demonstration.
    public override void afterUpdate() {
        List<Contact> contacts = new List<Contact>();
        for(Account acc : (List<Account>) Trigger.new) {
            contacts.add(createNewContact(acc)); 
        }
        Database.insert(contacts);
    }

    // After an Account is deleted, we create a Task to log the deletion event.
    public override void afterDelete() {
        List<Task> tasks = new List<Task>();
        for(Account acc : (List<Account>)Trigger.old) {
            Task task = new Task(Subject = 'Deleted Account ' + acc.Name, ActivityDate = Date.today());
            tasks.add(task);
        }
        Database.insert(tasks);
    }

    // Helper method to create a new Contact linked to the Account.
    public Contact createNewContact(Account acc) {
        return new Contact(FirstName = 'Carlos', LastName = 'Arango', AccountId = acc.Id, Email = 'carlos@adaptus.com');
    }

}