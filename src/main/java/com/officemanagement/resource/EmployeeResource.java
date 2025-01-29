package com.officemanagement.resource;

import com.officemanagement.model.Employee;
import com.officemanagement.model.Seat;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("/employees")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EmployeeResource {

    private SessionFactory sessionFactory;

    public EmployeeResource() {
        sessionFactory = new Configuration().configure().buildSessionFactory();
    }

    @GET
    public Response getAllEmployees() {
        try (Session session = sessionFactory.openSession()) {
            List<Employee> employees = session.createQuery(
                    "select new Employee(e.id, e.name, e.occupation, e.createdAt) from Employee e", 
                    Employee.class).list();
            return Response.ok(employees).build();
        }
    }
    @GET
    @Path("/{id}")
    public Response getEmployee(@PathParam("id") Long id) {
        try (Session session = sessionFactory.openSession()) {
            Employee employee = session.createQuery(
                "select e from Employee e " +
                "where e.id = :id", Employee.class)
                .setParameter("id", id)
                .uniqueResult();


            if (employee == null) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            return Response.ok(employee).build();
        }
    }

    @GET
    @Path("/{employeeId}/assign/{seatId}")
    public Response assignEmployeeToSeat(
            @PathParam("employeeId") Long employeeId,
            @PathParam("seatId") Long seatId) {

        try (Session session = sessionFactory.openSession()) {
            session.beginTransaction();

            // Fetch the employee and seat from the database
            Employee employee = session.get(Employee.class, employeeId);
            Seat seat = session.get(Seat.class, seatId);

            if (employee == null || seat == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("Employee or Seat not found")
                        .build();
            }

            // Assign the employee to the seat
            seat.setEmployee(employee);
            session.update(seat);

            session.getTransaction().commit();

            return Response.ok("Employee " + employee.getName() + " assigned to seat " + seat.getId()).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error assigning employee to seat: " + e.getMessage())
                    .build();
        }
    }
}

