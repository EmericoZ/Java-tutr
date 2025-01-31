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
    @Path("") // Endpoint: /api/stats
    @Produces(MediaType.APPLICATION_JSON) // Return JSON response
    public Response getStats() {
        try (Session session = sessionFactory.openSession()) {
            // Query to get the total number of employees
            Long totalEmployees = session.createQuery("SELECT COUNT(e) FROM Employee e", Long.class)
                                        .uniqueResult();

            // Query to get the total number of floors
            Long totalFloors = session.createQuery("SELECT COUNT(f) FROM Floor f", Long.class)
                                     .uniqueResult();

            // Query to get the total number of offices
            Long totalOffices = session.createQuery("SELECT COUNT(o) FROM OfficeRoom o", Long.class)
                                      .uniqueResult();

            // Query to get the total number of seats
            Long totalSeats = session.createQuery("SELECT COUNT(s) FROM Seat s", Long.class)
                                    .uniqueResult();

            // Create a JSON response with all the statistics
            String jsonResponse = String.format(
                "{\"totalEmployees\": %d, \"totalFloors\": %d, \"totalOffices\": %d, \"totalSeats\": %d}",
                totalEmployees, totalFloors, totalOffices, totalSeats
            );

            // Return the response with all the statistics
            return Response.ok()
                    .entity(jsonResponse)
                    .build();
        } catch (Exception e) {
            // Handle errors and return an appropriate response
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"message\": \"Failed to retrieve stats: " + e.getMessage() + "\"}")
                    .build();
        }
    }
}