package com.officemanagement.resource;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

@Path("/stats") // Base path for all stats-related endpoints
public class StatsResource {

    private SessionFactory sessionFactory;

    public StatsResource() {
        // Initialize the SessionFactory
        sessionFactory = new Configuration().configure().buildSessionFactory();
    }

    @GET
    @Path("/employees") // Endpoint: /api/stats/employees
    @Produces(MediaType.APPLICATION_JSON) // Return JSON response
    public Response getEmployeeStats() {
        try (Session session = sessionFactory.openSession()) {
            // Using Hibernate's Session to create the query
            Long totalEmployees = session.createQuery("SELECT COUNT(e) FROM Employee e", Long.class)
                                        .uniqueResult();

            // Return the response with the total number of employees
            return Response.ok()
                    .entity("{\"totalEmployees\": " + totalEmployees + "}")
                    .build();
        } catch (Exception e) {
            // Handle errors and return an appropriate response
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"message\": \"Failed to retrieve employee stats: " + e.getMessage() + "\"}")
                    .build();
        }
    }
}